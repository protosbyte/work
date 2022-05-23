import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Center(child: Container(width: 150,child: LinearProgressIndicator(color: Colors.red,backgroundColor: Colors.transparent,)));
  }
}

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({
    Key? key,
    required this.error,
    required this.retry,
  }) : super(key: key);

  final Object error;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'cannot load list',
            style: theme.textTheme.headline4?.copyWith(color: theme.errorColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            icon: const Icon(Icons.refresh),
            label:  Text('try again'),
            onPressed: retry,
          ),
        ],
      ),
    );
  }
}

class MyErrorLoader extends StatelessWidget {
  const MyErrorLoader({Key? key, required this.retry}) : super(key: key);
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        icon: const Icon(Icons.refresh),
        label:  Text('Try again'),
        onPressed: retry,
      ),
    );
  }
}

class MyEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Text('The cart is empty'));
  }
}
