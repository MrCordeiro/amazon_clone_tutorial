const express = require("express");
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");

const productRouter = express.Router();

// Get all products for a category
productRouter.get("/api/products", auth, async (req, res) => {
	try {
		const products = await Product.find({ category: req.query.category });
		res.json(products);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

// Get all products for a search query
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
	try {
		const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });
		res.json(products);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

// Add a product rating
productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);

		// Delete previous rating from that user if it exists
		for (const [index, rating] of product.ratings.entries()) {
			if (rating.userId == req.user) {
				product.ratings.splice(index, 1);
				break;
			}
		}

    const ratingSchema = {
      userId: req.user,
      rating,
    };

    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get "Deal of the Day" product: best rated product
productRouter.get("/api/deal-of-day", auth, async (req, res) => {
	try {
		let products = await Product.find({});
		// Calculate the total rating of each product and sort products by the total rating
		products = products.sort((a, b) => {
			let aRating = 0;
			let bRating = 0;
			for (const rating of a.ratings) {
				aRating += rating.rating;
			}
			for (const rating of b.ratings) {
				bRating += rating.rating;
			}
			return bRating - aRating;
		});
		res.json(products[0]); 

	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});


module.exports = productRouter;
