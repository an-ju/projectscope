<template>
    <span v-html="badge"></span>
</template>

<script>
    export default {
        name: "test_coverage",
        props: {
            d: String,
            s: String,
        },
        computed: {
            image: function () {
                return JSON.parse(JSON.parse(this.d)['image'])
            },
            badge: function () {
                return this.image['data']['test_badge']
            }
        },
    }
</script>

<style scoped>

</style>