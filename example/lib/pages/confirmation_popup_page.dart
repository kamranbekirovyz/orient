import 'package:example/widgets/button.dart';
import 'package:example/widgets/confirmation_popup.dart';
import 'package:example/widgets/demo_section.dart';
import 'package:example/widgets/toast.dart';
import 'package:flutter/material.dart';

class ConfirmationPopupPage extends StatelessWidget {
  const ConfirmationPopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoSection(
          title: 'Approve Feature',
          child: Button.small(
            onPressed: () {
              ConfirmationPopup.show(
                context: context,
                icon: Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Colors.green.shade300,
                ),
                title: 'Sure to approve this feature?',
                description:
                    'Once approved, it will be visible to the public.',
                confirmLabel: 'Yes, approve',
                cancelLabel: 'Cancel',
                onConfirm: () {
                  showToast(
                    context: context,
                    message: 'Feature approved.',
                  );
                },
              );
            },
            label: 'Show Dialog',
          ),
        ),
        DemoSection(
          title: 'Delete Item',
          child: Button.small(
            onPressed: () {
              ConfirmationPopup.show(
                context: context,
                icon: Icon(
                  Icons.delete_outline,
                  size: 48,
                  color: Colors.red.shade300,
                ),
                title: 'Delete this item?',
                description: 'This action cannot be undone.',
                confirmLabel: 'Delete',
                cancelLabel: 'Keep it',
                destructive: true,
                onConfirm: () {
                  showToast(
                    context: context,
                    message: 'Item deleted',
                  );
                },
              );
            },
            label: 'Show Dialog',
          ),
        ),
        DemoSection(
          title: 'Logout',
          child: Button.small(
            onPressed: () {
              ConfirmationPopup.show(
                context: context,
                icon: Icon(
                  Icons.logout,
                  size: 48,
                  color: Colors.orange.shade300,
                ),
                title: 'Log out of your account?',
                description:
                    'You will need to sign in again to access your data.',
                confirmLabel: 'Log out',
                destructive: true,
                cancelLabel: 'Stay',
                onConfirm: () {
                  showToast(
                    context: context,
                    message: 'Logged out',
                  );
                },
              );
            },
            label: 'Show Dialog',
          ),
        ),
        DemoSection(
          title: 'Discard Changes',
          child: Button.small(
            onPressed: () {
              ConfirmationPopup.show(
                context: context,
                icon: Icon(
                  Icons.edit_off_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                title: 'Discard unsaved changes?',
                description: 'Your changes will be lost.',
                confirmLabel: 'Discard',
                cancelLabel: 'Keep editing',
                onConfirm: () {
                  showToast(
                    context: context,
                    type: ToastType.info,
                    message: 'Changes discarded',
                  );
                },
              );
            },
            label: 'Show Dialog',
          ),
        ),
        DemoSection(
          title: 'Unsized Icon (auto 48x48)',
          child: Button.small(
            onPressed: () {
              ConfirmationPopup.show(
                context: context,
                icon: Icon(Icons.warning_amber, color: Colors.amber),
                title: 'Icon without size',
                description: 'The icon is passed without explicit size.',
                confirmLabel: 'Confirm',
                cancelLabel: 'Cancel',
                onConfirm: () {
                  showToast(
                    context: context,
                    message: 'Confirmed',
                  );
                },
              );
            },
            label: 'Show Dialog',
          ),
        ),
        DemoSection(
          title: 'Minimal (no icon, no description)',
          child: Button.small(
            onPressed: () {
              ConfirmationPopup.show(
                context: context,
                title: 'Are you sure?',
                confirmLabel: 'Yes',
                cancelLabel: 'No',
                onConfirm: () {
                  showToast(
                    context: context,
                    message: 'Clicked yes',
                  );
                },
              );
            },
            label: 'Show Dialog',
          ),
        ),
      ],
    );
  }
}
