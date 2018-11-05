<template>
    <div>
        <span v-html="badge"></span>
    </div>
</template>
<script>
    export default {
        name: "code_climate",
        props: {
            d: String,
            s: String,
        },
        computed: {
            null_data: function () {
                return this.d === 'null'
            },
            image: function () {
                return JSON.parse(JSON.parse(this.d)['image'])
            },
            badge: function () {
                return this.image['data']['maint_badge']
            }
        },
    }
</script>

<style scoped>
</style>