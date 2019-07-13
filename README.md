# What is this?

It's the [BYTEPATH tutorial](https://github.com/adnzzzzZ/blog/issues/30) but with my answers to the exercises.

# What's the BYTEPATH tutorial?

An incredibly detailed tutorial on how to make the game [BYTEPATH](https://store.steampowered.com/app/760330/BYTEPATH/). I happen to be very fond of Love2D so I'm looking forward to learning more about how other game developers utilize it.

# Tips and Tricks and Lessons Learned
- If you're using ZeroBrane Studio, beware of enabling `mobdebug`, as this can kill the performance of your game (usually enabling any sort of debugging tool will hurt performance)
- Time manipulation commands are super useful for debugging. You can build them into your game simply by multiplying `dt` by a time factor.
- What is `make_distrib.sh`? If you're running UNIX, this is an easy script that you can run to package your game into a `.love`. Useful when you want to distribute it. This script can be improved by excluding the actual script itself, but I find this works fine.
