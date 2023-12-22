import 'package:flutter/material.dart';
import 'package:mangakolekt/models/bloc/theme.dart';

class AddThemeButton extends StatefulWidget {
  const AddThemeButton({super.key});

  @override
  State<AddThemeButton> createState() => _AddThemeButtonState();
}

class _AddThemeButtonState extends State<AddThemeButton> {
  bool isShowingModal = false;
  var themeStore = ThemeStore.defaultTheme();

  void toggleModal() {
    setState(() {
      isShowingModal = !isShowingModal;
    });
  }

  @override
  build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          ElevatedButton(
            onPressed: toggleModal,
            child: const Text("Create theme"),
          ),
          Visibility(
            visible: isShowingModal,
            child: Container(
              width: 800,
              height: 600,
              decoration: BoxDecoration(
                  // color: theme.colorScheme.secondary,
                  //   border: Border.all(
                  //       color: theme.primaryColor,
                  //       style: BorderStyle.solid,
                  //       width: 1),
                  ),
              child: Column(
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
