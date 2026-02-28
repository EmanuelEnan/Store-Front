The following 3 points are core parts of this solution - 

1. TabBarView handles the horizontal swiping between categories. Each tab's content is a ProductList that shows products filtered by the selected category and search query.

2. NestedScrollView is the ONE vertical scrollable. It connects the header scroll with the list scroll so the SliverAppBar collapses correctly while the tab body continues scrolling.

3. There's an issue in that the products get slide inside the tab bar/ header as the NestedScrollView shares scroll momentum between the header and inner list. By using a single CustomScrollView with a SliverAppBar + SliverPersistentHeader for the tab bar
   might solve it.
