const express = require("express");
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const User = require("../models/user");

const userRouter = express.Router();

userRouter.post("/api/add-to-cart", auth, async (req, res) => {
	try {
		const { id } = req.body;
		const product = await Product.findById(id);
		let user = await User.findById(req.user);

		if (user.cart.length == 0) {
			user.cart.push({ product, quantity: 1 });
		} else {
			// Validate if product is already in cart and increase quantity if it is
			const index = user.cart.findIndex((item) => item.product._id.equals(id));
			if (index != -1) {
				user.cart[index].quantity++;
			} else {
				user.cart.push({ product, quantity: 1 });
			}
		}
		user = await user.save();
		res.json(user);
	} catch (e) {
		res.status(500).json({ error: e.message + e.stack });
	}
});

userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
	try {
		const { id } = req.params;
		let user = await User.findById(req.user);

		const index = user.cart.findIndex((item) => item.product._id.equals(id));
		if (index != -1) {
			if (user.cart[index].quantity > 1) {
				user.cart[index].quantity--;
			} else {
				user.cart.splice(index, 1);
			}
		}
		user = await user.save();
		res.json(user);
	} catch (e) {
		res.status(500).json({ error: e.message + e.stack });
	}
});

userRouter.post("api/save-user-address", auth, async (req, res) => {
	try {
		const { address } = req.body;
		let user = await User.findById(req.user);
		user.address = address;
		user = await user.save();
		res.json(user);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

userRouter.post("api/order", auth, async (req, res) => {
	try {
		const { cart, totalPrice, address } = req.body;
		let products = [];
		cart.forEach(async (item) => {
			let product = await Product.findById(item.product._id);
			if (product.quantity < item.quantity) {
				return res.status(400).json({ error: `${product.name} is out of stock` });
			}
			product.quantity -= item.quantity;
			products.push({ product: item.product, quantity: item.quantity });
			await product.save();
		});

		// Reset user cart
		let user = await User.findById(req.user);
		user.cart = [];
		await user.save();

		// Save order
		const order = new Order({
			products,
			totalPrice,
			address,
			userId: req.user,
			orderedAt: new Date.getTime(),
		});
		order = await order.save();
		res.json(order);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

module.exports = userRouter;

