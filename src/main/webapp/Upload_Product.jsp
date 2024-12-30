<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Product</title>
    <style>
        /* Consistent styles with the shopping cart page */
        body {
            font-family: 'Arial', sans-serif;
            color: #e0e0e0;
            background-color: #0c0c0c;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #333;
            color: white;
            padding: 10px 20px;
            text-align: center;
        }

        .form-container {
            width: 80%;
            margin: 20px auto;
            background-color: #1c1c1c;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }

        h2 {
            color: white;
            margin-bottom: 20px;
            text-align: center;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #e0e0e0;
        }

        input[type="text"], input[type="file"], input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #333;
            color: white;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #ff6347;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
        }

        button:hover {
            background-color: #ff4500;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="form-container">
    <h2>Upload Product</h2>
    <form action="UploadProductServlet" method="POST" enctype="multipart/form-data">
        <label for="name">Product Name:</label>
        <input type="text" id="name" name="name" placeholder="Enter the product name" required>

        <label for="description">Description:</label>
        <input type="text" id="description" name="description" placeholder="Enter a brief description" required>

        <label for="price">Price ($):</label>
        <input type="number" id="price" name="price" placeholder="Enter the product price" pattern="\d+(\.\d{2})?" title="Please enter a valid price (e.g., 19.99)" required>

        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" placeholder="Enter the product quantity" min="1" required>

        <label for="image">Product Image:</label>
        <input type="file" id="image" name="image" accept="image/*" required>

        <button type="submit">Upload Product</button>
    </form>
</div>

<script>
    const form = document.querySelector('form');
    const imageInput = document.getElementById('image');

    form.onsubmit = function() {
        const fileSize = imageInput.files[0].size / 1024 / 1024; // in MB
        if (fileSize > 5) {
            alert("File size exceeds 5MB. Please choose a smaller image.");
            return false;
        }
    };
</script>

</body>
</html>
