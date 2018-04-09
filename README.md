# WaterfallDemo
WaterfallDemo

本demo中，加入了移动cell大功能，但是测试发现，不论怎样移动，都会移动到index为0到位置，也就是说，destinationIndexPath.item始终为0。如果collectionview布局不是瀑布流布局，而是正常的均等布局，效果正常。如果你有好的策略，欢迎指教。github issues我（[github地址 ](https://github.com/diankuanghuolong/WaterfallDemo)）。

```
瀑布流布局，有几点需要明确：
第一：要求item的列宽（如果是竖向滑动）相等，或者item的行高相等（如果是横向滑动，我好像没见过这样的）。
第二：数据到底是如何给呢？感觉布局没有规律啊。如果是竖向滑动（下边都安照竖向滑动来说），那么需要计算每列最小y值。比如有3列，每列有两个item，现在拿到一个数据，放到哪里呢？哪列的y小，放到哪列。如果现在第2列y值最小，那么你看到的界面就是，第二列最短。就在第二列下边放就好。
第三：布局控件collectionFlowLayout，自定义。最好自定义，因为，瀑布流布局，主要是对布局控件flowlayout的高度对计算和处理。
第四：这个有点好笑啦，不过也很重要（如果你真地不知道）。item的高度咋算呢？通常，你的瀑布流布局（以图片列表为例），应该是有严格的设计标准的。
也就是说，看似杂乱，实则有序。那么这就该是提前设计好的，提前设计好的东西，最好就是后台给你了。后台给你列表中每个位置的图片是哪个，多宽（固定），多高。然后，你再根据页面上有多少列，每列的宽度是多少，算出多高（这个应该会的，比如给你一个image，如何不失真啊？ 宽度固定的话，那么高度就是cgfloat h = w* img.height/img.width）。
第五：布局控件flowlayout中，重写，preparelayout方法，并调整布局。网上一大把，自己去找找吧。封装一个适合自己，自己喜欢的布局控件，然后就可以得手的应用了。
```

![展示图片](https://github.com/diankuanghuolong/WaterfallDemo/blob/master/showImgs/waterfallDemo.gif)
