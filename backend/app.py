# app.py
"""
Flask API for Level Upp authentication.
- /signup : create a user (enforces unique email & username)
- /login  : sign in with username OR email + password
"""

from flask import Flask, request, jsonify
from flask_bcrypt import Bcrypt
from flask_cors import CORS
from pymongo import MongoClient, errors
from dotenv import load_dotenv
import os
import re
from email_validator import validate_email, EmailNotValidError 

# ────────────────────────────── Setup ──────────────────────────────
load_dotenv()

app = Flask(__name__)
app.config["SECRET_KEY"] = os.getenv("FLASK_SECRET", "dev-secret")

CORS(app, resources={r"/*": {"origins": "*"}})  # Allow requests from any origin
bcrypt = Bcrypt(app)

# ─────────────────────── MongoDB Connection ────────────────────────
client = MongoClient(os.getenv("MONGODB_URI"))
db = client["level_upp"]
users_col = db["users"]

# Ensure uniqueness
users_col.create_index("email", unique=True)
users_col.create_index("username", unique=True)

# ──────────────────────── Helper Functions ─────────────────────────
def is_valid_email(email: str) -> bool:
    """Validate email using email_validator package."""
    try:
        validate_email(email)
        return True
    except EmailNotValidError:
        return False
    
def is_strong_password(pwd: str) -> bool:
    """Enforce password strength: 8+ chars, upper, lower, digit, special."""
    return re.match(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!#%*?&]{8,}$", pwd) is not None

def _hash_pwd(pwd: str) -> str:
    return bcrypt.generate_password_hash(pwd).decode()

def _check_pwd(pwd: str, hashed: str) -> bool:
    return bcrypt.check_password_hash(hashed, pwd)

# ───────────────────────── Signup Route ─────────────────────────────
@app.route("/signup", methods=["POST"])
def signup():
    data = request.get_json(force=True)
    required = ["first_name", "last_name", "email", "username", "password"]
    
    # Check missing fields
    if not all(field in data and data[field] for field in required):
        return jsonify({"error": "missing_fields"}), 400

    email = data["email"].strip().lower()
    username = data["username"].strip().lower()
    password = data["password"]

    # Email validation
    if not is_valid_email(email):
        return jsonify({"error": "invalid_email"}), 400

    # Password validation
    if not is_strong_password(password):
        return jsonify({"error": "weak_password"}), 400

    user_doc = {
        "first_name": data["first_name"],
        "last_name": data["last_name"],
        "email": email,
        "username": username,
        "password": _hash_pwd(password),
    }

    try:
        users_col.insert_one(user_doc)
        return jsonify({"msg": "user_created"}), 201

    except errors.DuplicateKeyError as e:
        dup_field = "email" if "email" in str(e) else "username"
        return jsonify({"error": f"{dup_field}_exists"}), 409

# ───────────────────────── Login Route ─────────────────────────────
@app.route("/login", methods=["POST"])
def login():
    data = request.get_json(force=True)
    identifier = data.get("identifier", "").strip().lower()
    password = data.get("password", "")

    if not identifier or not password:
        return jsonify({"error": "missing_credentials"}), 400

    user = users_col.find_one({
        "$or": [{"email": identifier}, {"username": identifier}]
    })

    if user and _check_pwd(password, user["password"]):
        return jsonify({"msg": "login_success", "user_id": str(user["_id"])}), 200

    return jsonify({"error": "invalid_credentials"}), 401

# ─────────────────────── Run Server ───────────────────────────────
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

