<template>
    <div>
      <TheHeader/>
      <navbar/>
    </div>
</template>

<script setup>
definePageMeta({
  middleware: "auth",
})

</script>