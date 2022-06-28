const mongooose = require("mongoose");

const userSchema = mongooose.Schema({
	name: { required: true, type: String, trim: true },
	email: {
		required: true,
		type: String,
		trim: true,
    validate: {
      validator: (value) => {
        const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return value.match(re);
      },
      message: "Invalid email address",

    }
	},
	password: {
    required: true, 
    type: String, 
    validate: {
      validator: (value) => {
        return value.length >= 6;
      },
      message: "Password must be at least 6 characters"
    }
  },
  address: {
    type: String,
    default: "",
  },
  type: {
    type: String,
    default: "user",
  }
  // cart
});

const User = mongooose.model("User", userSchema);

module.exports = User;