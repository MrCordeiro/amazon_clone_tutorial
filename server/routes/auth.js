const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const auth = require("../middlewares/auth");

const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
	const { name, email, password } = req.body;
	try {
		const existingUser = await User.findOne({ email });
		if (existingUser) {
			return res.status(400).json({ error: "User already exists." });
		}

		const hashedPassword = await bcryptjs.hash(password, 8);

		let user = new User({ email, password: hashedPassword, name });
		user = await user.save();
		res.json(user);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

authRouter.post("/api/signin", async (req, res) => {
	const { email, password } = req.body;
	try {
		const user = await User.findOne({ email });
		if (!user) {
			return res.status(400).json({ error: "User does not exist." });
		}

		const isMatch = await bcryptjs.compare(password, user.password);
		if (!isMatch) {
			return res.status(400).json({ error: "Wrong email/password." });
		}

		const token = jwt.sign({ id: user._id }, process.env.PRIVATE_KEY);
		res.json({ token, ...user._doc });
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

authRouter.post("/tokenIsValid", async (req, res) => {
	try {
		const token = req.header("x-auth-token");
		if (!token) return res.json(false);
		const verified = jwt.verify(token, process.env.PRIVATE_KEY);
		if (!verified) return res.json(false);
		const user = await User.findById(verified.id);
		if (!user) return res.json(false);
		res.json(true);
	} catch (e) {
		res.status(500).json({ error: e.message });
	}
});

authRouter.get('/', auth, async (req, res) => {
	const user = await User.findById(req.user);
	res.json({...user._doc, token: req.token});
})

module.exports = authRouter;
