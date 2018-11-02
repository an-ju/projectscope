<template>
    <div>
        <div :style="{ width: comment_width }" class="pr-commented" >{{ commented }} </div>
        <div :style="{ width: uncommented_width }" class="pr-uncommented" >{{ total - commented}}</div>
    </div>
</template>

<script>
    export default {
        name: "pull_requests",
        props: {
            d: String,
            s: String,
        },
        computed: {
            image: function () {
                return JSON.parse(JSON.parse(this.d)['image'])
            },
            commented: function () {
                return this.image['data']['commented']
            },
            open: function () {
                return this.image['data']['open']
            },
            total: function () {
                return this.image['data']['total']
            },
            comment_width: function () {
                return 100.0 * this.commented / this.total + '%'
            },
            uncommented_width: function () {
                return 100.0 * (this.total - this.commented) / this.total + '%'
            }
        }
    }
</script>

<style lang="scss" scoped>
.pr-uncommented {
    float: left;
    background-color: green;
}
.pr-commented {
    float: left;
    background-color: red;
}
</style>