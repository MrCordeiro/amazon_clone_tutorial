const express = require("express");
const mongooose = require("mongoose");
const adminRouter = require("./routes/admin");
require("dotenv").config();

const authRouter = require("./routes/auth");
const productRouter = require("./routes/product");

const PORT = process.env.PORT || 3000;
const app = express();
const DB = `mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@amazon-flutter-tutorial.1aa1vax.mongodb.net/?retryWrites=true&w=majority`;

// Middleware
app.use(express.json())
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);

// Connections
mongooose
	.connect(DB)
	.then(() => {
		console.log("Connected to MongoDB");
	})
	.catch((err) => {
		console.log(DB);
		console.log(err);
	});

app.listen(PORT, "0.0.0.0", () => {
	console.log(`Server listening on port ${PORT}`);
});
