const express = require("express");
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");

const adminRouter = express.Router();

// Add product
adminRouter.post("/admin/products", admin, async (req, res) => {
	try {
		const { name, description, price, quantity, images, category } = req.body;
		let product = new Product({
			name,
			description,
			price,
			quantity,
			images,
			category,
		});
		product = await product.save();
		res.json(product);
	} catch (e) {
		res.status(500).json({ error: e.message + e.stack });
	}
});

// Get all products
adminRouter.get("/admin/products", admin, async (req, res) => {
	try {
		const products = await Product.find({});
		res.json(products);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

// Delete product
adminRouter.delete("/admin/products/:id", admin, async (req, res) => {
	try {
		const product = await Product.findByIdAndDelete(req.params.id);
		// ? Should the image file also be deleted?
		if (!product) {
			return res.status(404).json({ error: "Product not found" });
		}
		res.status(204).json({ success: "Product deleted" });
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});


module.exports = adminRouter;
