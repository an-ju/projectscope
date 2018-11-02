<template>
    <div class="chart_place" ></div>
    
</template>

<script>
    export default {
        name: "MetricTableProjectMetric",
        data() {
            return {
                data: {}
            }
        },
        created() {
            this.data = JSON.parse(this.$attrs.data)
        }


    }
</script>

<style scoped>

</style>