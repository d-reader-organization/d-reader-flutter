import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IntroForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  const IntroForm({
    super.key,
    required this.formKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntroFormState();
}

class _IntroFormState extends ConsumerState<IntroForm> {
  Timer? _debouncer;

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('TO-DO'),
    );
    //     final provider = ref.watch(myWalletProvider); TODO change INTRO FORM
    // return provider.maybeWhen(
    //   orElse: () {
    //     return const Text('Failed to load wallet');
    //   },
    //   loading: () {
    //     return const SizedBox();
    //   },
    //   data: (wallet) {
    //     if (wallet == null) {
    //       return const Text('No wallet');
    //     }
    //     return Form(
    //       key: widget.formKey,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           CustomTextField(
    //             labelText: 'Username',
    //             hintText: 'eg. BunBun',
    //             autovalidateMode: AutovalidateMode.onUserInteraction,
    //             onValidate: (value) {
    //               return validateUsername(value: value, ref: ref);
    //             },
    //             onChange: (value) {
    //               if (_debouncer?.isActive ?? false) {
    //                 _debouncer?.cancel();
    //               }
    //               _debouncer =
    //                   Timer(const Duration(milliseconds: 200), () async {
    //                 final validatorNotifier =
    //                     ref.read(isValidWalletNameValue.notifier);
    //                 ref.read(walletNameProvider.notifier).state = value;
    //                 if (value.isEmpty) {
    //                   validatorNotifier.state = false;
    //                   return;
    //                 }
    //                 final result = await ref
    //                     .read(validateWalletNameProvider(value).future);
    //                 validatorNotifier.state = result;
    //               });
    //             },
    //           ),
    //           ref.watch(globalStateProvider).isLoading
    //               ? const Center(
    //                   child: SizedBox(
    //                     height: 48,
    //                     width: 48,
    //                     child: CircularProgressIndicator(
    //                       color: ColorPalette.dReaderBlue,
    //                     ),
    //                   ),
    //                 )
    //               : ref.watch(globalStateProvider).isReferred
    //                   ? const SizedBox(
    //                       height: 48,
    //                       width: 48,
    //                       child: Icon(
    //                         Icons.check_circle_outline_outlined,
    //                         color: ColorPalette.dReaderGreen,
    //                         size: 48,
    //                       ),
    //                     )
    //                   : Column(
    //                       children: [
    //                         CustomTextField(
    //                           labelText: 'Referrer',
    //                           hintText: 'Type in referral code',
    //                           onChange: (String value) {
    //                             ref.read(referrerNameProvider.notifier).state =
    //                                 value;
    //                           },
    //                         ),
    //                       ],
    //                     ),
    //         ],
    //       ),
    //     );
    //   },
  }
}
