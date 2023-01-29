const express = require("express");
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
const Order = require("../models/order");

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

// Get all orders
adminRouter.get("/admin/orders", admin, async (req, res) => {
	try {
		const orders = await Order.find({});
		res.json(orders);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

// Update order status
adminRouter.put("/admin/change-order-status", admin, async (req, res) => {
	try {
		const { id, status } = req.body;
		let order = await Order.findById(id);
		order.status = status;
		order = await order.save();
		res.json(order);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

// Get total and category earnings
async function _fetchEarnings(category = null) {
	const orders = category
		? await Order.find({ "products.product.category": category })
		: await Order.find({});

	return orders.reduce((acc, order) => {
		return (
			acc +
			order.reduce((subtotal, product) => {
				return subtotal + product.price * product.quantity;
			}, 0)
		);
	}, 0);
}

adminRouter.get("/admin/analytics", admin, async (req, res) => {
	try {
		// Total Earnings
		const totalEarnings = await _fetchEarnings();
		// Category Earnings
		const mobileEarnings = await _fetchEarnings("Mobiles");
		const essentialEarnings = await _fetchEarnings("Essentials");
		const applianceEarnings = await _fetchEarnings("Appliances");
		const booksEarnings = await _fetchEarnings("Books");
		const fashionEarnings = await _fetchEarnings("Fashion");

		const earnings = {
			totalEarnings,
			mobileEarnings,
			essentialEarnings,
			applianceEarnings,
			booksEarnings,
			fashionEarnings,
		};

		res.json(earnings);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

module.exports = adminRouter;

