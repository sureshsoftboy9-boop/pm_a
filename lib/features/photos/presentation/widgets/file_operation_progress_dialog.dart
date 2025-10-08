import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/file_operation_bloc.dart';
import '../bloc/file_operation_state.dart';

class FileOperationProgressDialog extends StatelessWidget {
  const FileOperationProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileOperationBloc, FileOperationState>(
      builder: (context, state) {
        if (state.status == OperationStatus.none) {
          return const SizedBox.shrink();
        }

        return AlertDialog(
          title: Text(_getTitle(state.status)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.currentOperation != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(state.currentOperation!),
                ),
              if (state.status == OperationStatus.inProgress)
                LinearProgressIndicator(value: state.progress),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    state.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
          actions: _buildActions(context, state),
        );
      },
    );
  }

  String _getTitle(OperationStatus status) {
    switch (status) {
      case OperationStatus.inProgress:
        return 'Processing...';
      case OperationStatus.completed:
        return 'Complete';
      case OperationStatus.failed:
        return 'Error';
      default:
        return '';
    }
  }

  List<Widget> _buildActions(BuildContext context, FileOperationState state) {
    final actions = <Widget>[];

    if (state.status == OperationStatus.completed) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      );
    } else if (state.status == OperationStatus.failed) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      );
    }

    return actions;
  }
}
