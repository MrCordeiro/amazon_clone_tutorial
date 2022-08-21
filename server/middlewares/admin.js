const jwt = require("jsonwebtoken");
const User = require("../models/user");

/**
 * Validate request user has the role of admin
 * @param {*} req - Request object
 * @param {*} res - Response object
 * @param {*} next - Next middleware
 * @returns
 */
const admin = async (req, res, next) => {
	try {
		const token = req.header("x-auth-token");
		if (!token)
			return res.status(401).json({ msg: "No token, authorization denied" });

		const verified = jwt.verify(token, process.env.PRIVATE_KEY);
		if (!verified)
			return res
				.status(401)
				.json({ msg: "Token verification failed, authorization denied" });
		const user = await User.findById(verified.id);
		if (user.type != "admin") {
			return res.status(401).json({ msg: "User is not an admin" });
		}
		req.user = verified.id;
		req.token = token;
		next();
	} catch (err) {
		res.status(500).json({ msg: err.message });
	}
};

module.exports = admin;
