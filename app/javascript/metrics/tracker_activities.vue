<template>
   <div class="dropdown">
       <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" :class="bar_color" class="float-left text-white dropdown-toggle px-3 rounded-full w-full">
           {{ this.transitions.length }}
       </div>
       <ul class="dropdown-menu">
           <li v-for="act in this.activities">
               <p class="px-3 py-1 text-left text-grey">{{ act.primary_resources[0].name }}</p>
               <p class="px-3 py-1 text-left text-grey-darker">{{ act.message }}</p>
           </li>
       </ul>
   </div>
</template>

<script>
    export default {
        name: "tracker_activities",
        props: {
            image: Object,
        },
        computed: {
            activities: function () {
                return this.image['data']['activities']
            },
            transitions: function () {
                return this.image['data']['transitions']
            },
            bar_color() {
                if (this.transitions.length > 0) {
                    return 'bg-green-dark'
                } else {
                    return 'bg-red-dark'
                }
            }
        },
    }
</script>

<style scoped>

</style>