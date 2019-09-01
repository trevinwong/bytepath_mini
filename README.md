# What is this?

**BYTEPATH Mini** is the un-official Android port of adnzzzzZ's [BYTEPATH tutorial](https://github.com/adnzzzzZ/blog/issues/30). This repository serves two purposes:

1. **To help people following the tutorial.** Since LOVE has updated to 11.0 and libraries have changed, some of the code in the tutorial has been rendered obsolete. If you find yourself stuck on parts of the tutorial that mysteriously do not seem to work, you can refer to the appropriate commit in my repository to see what I've done to make it work (I have labelled each commit with the appropriate section and exercise number.)

As of *August 31, 2019*, all the exercises up to 227 have been completed successfully. I have chosen not to do the exercises past 227 since they are not applicable to the Android port.

Note: some of the commits aren't the cleanest, due to me occasionally fixing previous blunders and randomly commenting on things. If you have any questions about the code, don't hesitate to email me at *trevinwong@gmail.com*.

2. **To house the new code for the port.** 

If you like BYTEPATH Mini, I suggest you buy the [original version](https://store.steampowered.com/app/760330/BYTEPATH/), which has way more content and is way more polished.

# Tips and Tricks and Lessons Learned
- If you're using ZeroBrane Studio, beware of enabling `mobdebug`, as this can kill the performance of your game (usually enabling any sort of debugging tool will hurt performance)
- Time manipulation commands are super useful for debugging. You can build them into your game simply by multiplying `dt` by a time factor.
- On that same note, a "pause" and "resume" command is also helpful, which you can do by multiplying `dt` by `0`, or just wrapping your update calls in an `if` block.
- What is `make_distrib.sh`? If you're running UNIX, this is an easy script that you can run to package your game into a `.love`. Useful when you want to distribute it. This script can be improved by excluding the actual script itself, but I find this works fine.
- A useful idiom you can use for Lua:

```lua
for _, val in ipairs(table or {}) do
end
```

This way, you don't need to check whether or not the table exists. Why does this work? The `or` operator will always return the second argument if the first argument is false.
- Some useful functions: 
  - `table.sort`, for sorting tables
  - `unpack` for returning all elements inside of the table. Note that `unpack` only returns the first returned value if it is not the last one in a list of expressions. 
  - `s:find`, where `s` is a string, finds a pattern inside of the string and returns the start and end indices of it.
  - `type` returns the type of the value.
  - *LOVE-Specific:* `font:getWidth(text)` returns the width of the given text using the font that `font` represents.
- *LOVE-Specific:* Colors work differently in LOVE 11.0. They range from `0-1` instead of `0-255` now.
- *LOVE-Specific:* The functions `love.keyboard.isDown()` and `love.mouse.isDown()` now throw exceptions instead of returning false upon an invalid key constant.
- Always define a `length` function for tables. The `#` operator only returns the largest indice in a table.
- *LOVE-Specific:* Always clear your Canvas after using it, otherwise you'll run into an error at the end of the draw loop.
- *ZeroBrane-Specific:* `CTRL+I` re-formats the current file for you. Use this all the time to avoid wasting time on re-formatting text.
- Handy simplification for operator precedence: numerical `>` comparison `>` boolean
- Functions by default return `nil`, which is equivalent to `false`, so if you're designing a function that returns a `boolean`, you only need to insert the `true` case. Though it is probably much more clear if you explicitly return `false`.
- Debug utilities are extremely useful. An example: adding the ability to slow down or pause your game using hotkeys. Very easy to implement, and helps a lot with debugging.
  - Something I've wanted to do but haven't had the chance to: add a debug function to iterate through all game objects, and draw their bounding boxes (if they have self.w, self.h, self.x, self.y attributes, which every game object should.) Previously I had done this on an object by object basis and often removed the code after I fixed the bug (in which I would then re-add it shortly afterwards anyways), which is really inefficient.
