const express = require("express");
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");

const productRouter = express.Router();

// Get all products for a category
productRouter.get("/api/products", auth, async (req, res) => {
	try {
		const products = await Product.find({category: req.query.category});
		res.json(products);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

module.exports = productRouter;
