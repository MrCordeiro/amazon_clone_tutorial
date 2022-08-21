const express = require("express");
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");

const adminRouter = express.Router();

// Add product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
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
		res.status(500).json({ error: e.message + " HELLO " + e.stack });
	}
});

module.exports = adminRouter;
