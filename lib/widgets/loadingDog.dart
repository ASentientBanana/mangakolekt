import 'package:flutter/material.dart';

class LoadingDog extends StatefulWidget {
  const LoadingDog({Key? key}) : super(key: key);

  @override
  State<LoadingDog> createState() => _LoadingDogState();
}

class _LoadingDogState extends State<LoadingDog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    // _controller = AnimationController(
    //     duration: const Duration(milliseconds: 200), vsync: this);
    // _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(children: [
        Center(
          child: Image.asset('assets/images/dog_no_color.png'),
        ),
        Center(
          child: FadeTransition(
            opacity:
                CurvedAnimation(curve: Curves.easeInOut, parent: _animation),
            // opacity: 1,
            child: Image.asset('assets/images/dog_color.png'),
          ),
        )
      ]),
    );
  }
}
