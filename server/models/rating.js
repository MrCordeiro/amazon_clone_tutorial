const mongooose = require("mongoose");

const ratingSchema = mongooose.Schema({
  userId: { type: String, required: true },
  rating: { type: Number, required: true },
});

module.exports = ratingSchema;