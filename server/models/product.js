const mongooose = require("mongoose");

const productSchema = mongooose.Schema({
	name: {
		type: String,
		required: true,
		trim: true,
	},
	description: {
		type: String,
		required: true,
		trim: true,
	},
	price: {
		type: Number,
		required: true,
	},
	quantity: {
		type: Number,
		required: true,
	},
	images: [
		{
			type: String,
			required: true,
		},
	],
	category: {
		type: String,
		required: true,
	},
});

const Product = mongooose.model("Product", productSchema);

module.exports = {Product, productSchema};
