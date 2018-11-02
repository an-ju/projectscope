<template>
    <div style="height:30px">
        <svg viewBox="0 0 300 100">
            <g>
                <circle cx="30" cy="50" r="15" :fill="ci_color"></circle>
                <text x="60" y="50">{{ ci_status }}</text>
            </g>
        </svg>
    </div>
</template>

<script>
    export default {
        name: "travis_ci",
        props: {
            d: String,
            s: String,
        },
        computed: {
            image: function () {
                return JSON.parse(JSON.parse(this.d)['image'])
            },
            ci_status: function () {
                return this.image['data']['current_state']
            },
            ci_color: function () {
                if (this.ci_status === 'passed') {
                    return 'green'
                } else {
                    return 'red'
                }
            }
        }
    }
</script>

<style scoped>
    svg{
        height: 100%;
    }

</style>