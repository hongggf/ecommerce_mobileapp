import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<Homepage> {
  int selectedIndex = 0;
  int currentIndex = 0;
  var scrollController = ScrollController();
  List<Widget> silderIMG = [
    Image.asset("assets/images/slider1.jpg", fit: BoxFit.cover),
    Image.asset("assets/images/slider2.jpg", fit: BoxFit.cover),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ecommerce Urban'),
          centerTitle: true,
        ),
        drawer: Drawer(
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              1),
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menuklskdlfk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _buildslider(), // your slider
                ),
              ),
        ),
    bottomNavigationBar: _buildbuttomNav(), // <-- fixed at bottom
  );
  }

  Widget _buildslider() {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 220,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              }),
          items: silderIMG.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: i,
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 10,
          left: 160,
          child: AnimatedSmoothIndicator(
            activeIndex: currentIndex,
            count: silderIMG.length,
            effect: ExpandingDotsEffect(
                dotWidth: 15,
                dotHeight: 15,
                activeDotColor: Colors.white,
                dotColor: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget _buildbuttomNav() {
    return GNav(
      selectedIndex: selectedIndex,
      onTabChange: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      rippleColor: const Color.fromARGB(255, 247, 244, 244),
      hoverColor: Colors.grey,
      haptic: true,
      tabBorderRadius: 15,
      tabActiveBorder: Border.all(color: Colors.black, width: 1),
      tabBorder: Border.all(color: Colors.grey, width: 1),
      tabShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
      ],
      curve: Curves.easeOutExpo,
      duration: Duration(milliseconds: 500),
      gap: 8,
      color: const Color.fromARGB(255, 28, 27, 27),
      activeColor: Colors.purple,
      iconSize: 24,
      tabBackgroundColor: Colors.purple.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tabs: [
        GButton(icon: Icons.home, text: 'Home'),
        GButton(icon: Icons.search_outlined, text: 'Search'),
        GButton(icon: Icons.person, text: 'Profile'),
      ],
    );
  }
}
