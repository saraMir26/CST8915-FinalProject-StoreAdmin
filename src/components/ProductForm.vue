<template>
  <div class="action-button">
    <button @click="saveProduct" class="button">Save Product</button>
  </div>

  <br />

  <div v-if="showValidationErrors" class="error">
    <br />
    <ul v-for="error in validationErrors" :key="error">
      <li>{{ error }}</li>
    </ul>
  </div>

  <div class="product-form">
    <table>
      <tr>
        <td><label for="product-name">Name</label></td>
        <td><input id="product-name" placeholder="Product Name" v-model="product.name" /></td>
      </tr>

      <tr>
        <td><label for="product-price">Price</label></td>
        <td><input id="product-price" placeholder="Product Price" v-model="product.price" type="number" step="0.01" /></td>
      </tr>

      <tr>
        <td><label for="product-description">Description</label></td>
        <td>
          <textarea rows="8" id="product-description" placeholder="Product Description" v-model="product.description"></textarea>
          <input type="hidden" id="product-id" placeholder="Product ID" v-model="product.id" />
        </td>
      </tr>

      <tr>
        <td><label for="product-image">Image</label></td>
        <td><input id="product-image" placeholder="Product Image URL or Path" v-model="product.image" /></td>
      </tr>
    </table>
  </div>
</template>

<script>
const productServiceUrl = 'http://localhost:3002/';

export default {
  name: 'ProductForm',
  props: ['products'],
  emits: ['addProductsToList', 'updateProductInList'],
  data() {
    return {
      product: {
        id: 0,
        name: '',
        image: '/placeholder.png',
        description: '',
        price: 0.00
      },
      showValidationErrors: false
    }
  },
  mounted() {
    if (this.$route.params.id) {
      const product = this.products.find(product => product.id == this.$route.params.id)
      this.product = Object.assign({}, product);
    }
  },
  computed: {
    validationErrors() {
      let errors = [];

      if (this.product.name.length === 0) {
        errors.push('Please enter a value for the name field');
      }

      if (this.product.description.length === 0) {
        errors.push('Please enter a value for the description field');
      }

      if (this.product.price <= 0) {
        errors.push('Please enter a value greater than 0 for the price field');
      }

      if (!this.product.image || this.product.image.length === 0) {
        errors.push('Please enter a value for the image field');
      }

      return errors;
    }
  },
  methods: {
    saveProduct() {
      if (this.validationErrors.length > 0) {
        this.showValidationErrors = true;
        return;
      }

      let method = 'PUT';
      let path = this.$route.path;

      if (path.includes('add')) {
        method = 'POST';
      }

      this.product.price = parseFloat(this.product.price);

      fetch(`${productServiceUrl}`, {
        method: method,
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(this.product)
      })
        .then(response => response.json())
        .then(product => {
          alert('Product saved successfully')
          if (method === 'PUT') {
            this.$emit('updateProductInList', this.product);
          } else {
            this.$emit('addProductsToList', product);
          }
          this.$router.push(`/product/${product.id}`);
        })
        .catch(error => {
          console.log(error)
          alert('Error occurred while saving product')
        })
    }
  }
}
</script>

<style scoped>
ul {
  justify-content: center;
  list-style: none;
  margin: 0;
  padding: 0;
  width: 100%;
  color: #ff0000;
}

img {
  width: 100%;
}

table {
  border-collapse: collapse;
}

td {
  vertical-align: center;
  border: none;
}

.product-form {
  display: flex;
  justify-content: center;
}

.product-form input,
.product-form textarea {
  padding: 5px;
  margin: 5px;
  width: 100%;
}
</style>