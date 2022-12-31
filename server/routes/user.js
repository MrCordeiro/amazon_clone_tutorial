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

		if (!user.cart.length == 0) {
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

module.exports = userRouter;
