<template>
  <div class="order-detail" v-if="orderExists">
    <div class="action-button">
      <button @click="completeOrder">Complete Order</button>
    </div>

    <div class="order-header">
      <p><b>Order ID:</b> {{ order.orderId }}</p>
      <p><b>Customer ID:</b> {{ order.customerId }}</p>
      <p><b>Status:</b> {{ order.status }}</p>
    </div>

    <table>
      <thead>
        <tr>
          <th>Product ID</th>
          <th>Product Name</th>
          <th>Quantity</th>
          <th>Price</th>
          <th>Total</th>
        </tr>
      </thead>

      <tr v-for="item in order.items" :key="item.productId">
        <td>{{ item.productId }}</td>
        <td>{{ productLookup(item.productId) }}</td>
        <td>{{ item.quantity }}</td>
        <td>${{ item.price.toFixed(2) }}</td>
        <td>${{ (item.quantity * item.price).toFixed(2) }}</td>
      </tr>
    </table>
  </div>

  <div v-else>
    <h3>Oops! That order was not found.</h3>
  </div>
</template>

<script>
export default {
  name: 'OrderDetail',
  props: ['orders', 'products'],
  emits: ['completeOrder'],
  data() {
    return {
      order: null
    }
  },
  computed: {
    orderExists() {
      return !!this.order
    }
  },
  mounted() {
    this.getOrder()
  },
  methods: {
    getOrder() {
      this.order = this.orders.find(order => order.orderId == this.$route.params.id)

      if (!this.order) {
        fetch(`/makeline/order/${this.$route.params.id}`)
          .then(res => res.json())
          .then(data => {
            this.order = data
          })
          .catch(err => console.error(err))
      }
    },
    completeOrder() {
      this.$emit('completeOrder', this.order.orderId)
    },
    productLookup(id) {
      const product = this.products.find(p => p.id === id)
      return product ? product.name : 'Unknown Product'
    }
  }
}
</script>

<style scoped>
.order-detail {
  text-align: left;
}
</style>