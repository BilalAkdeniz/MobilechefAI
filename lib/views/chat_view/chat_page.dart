import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/chat_viewmodel.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/chat/speech_status_indicator.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/chat_input_area.dart';
import '../../widgets/chat/chat_menu.dart';
import '../../widgets/chat/welcome_card.dart';
import '../../widgets/chat/ingredient_chip_list.dart';
import '../../theme/responsive.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _logout() async {
    final loginVm = Provider.of<LoginViewModel>(context, listen: false);
    await loginVm.repository.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: 'MobileChef AI',
              subtitle: 'Malzemelerinizle tarif oluşturun',
              icon: Icons.smart_toy,
              trailing: ChatMenu(
                onLogout: _logout,
                onClearMessages: () =>
                    context.read<ChatViewModel>().clearMessages(),
                onClearAll: () => context.read<ChatViewModel>().clearAll(),
              ),
            ),
            const SpeechStatusIndicator(),
            Expanded(
              child: Consumer<ChatViewModel>(
                builder: (context, vm, child) {
                  if (vm.messages.isEmpty && vm.ingredients.isEmpty) {
                    return const WelcomeCard();
                  }
                  _scrollToBottom();
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.messages.length,
                    itemBuilder: (context, index) {
                      final msg = vm.messages[index];
                      return MessageBubble(
                        message: msg['content'],
                        isUser: msg['type'] == 'user',
                        isError: msg['type'] == 'error',
                        timestamp: msg['timestamp'],
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<ChatViewModel>(
              builder: (context, vm, child) {
                if (vm.ingredients.isEmpty) return const SizedBox.shrink();
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(
                      Responsive.width(context, 0.04),
                      Responsive.height(context, 0.01),
                      Responsive.width(context, 0.04),
                      0),
                  padding: EdgeInsets.all(Responsive.width(context, 0.04)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade50,
                        Colors.orange.shade100.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade200.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.orange.shade200.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.all(Responsive.width(context, 0.02)),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade500,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.orange.shade500.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.kitchen,
                              size: Responsive.width(context, 0.04),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: Responsive.width(context, 0.025)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Malzemelerim',
                                  style: TextStyle(
                                    fontSize: Responsive.font(context, 0.035),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                                Text(
                                  '${vm.ingredients.length} malzeme eklendi',
                                  style: TextStyle(
                                    fontSize: Responsive.font(context, 0.03),
                                    color: Colors.orange.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (vm.ingredients.isNotEmpty)
                            GestureDetector(
                              onTap: () => vm.clearIngredients(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Responsive.width(context, 0.025),
                                  vertical: Responsive.height(context, 0.006),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.clear_all,
                                      size: Responsive.width(context, 0.035),
                                      color: Colors.red.shade600,
                                    ),
                                    SizedBox(
                                        width: Responsive.width(context, 0.01)),
                                    Text(
                                      'Temizle',
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontSize:
                                            Responsive.font(context, 0.03),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: Responsive.height(context, 0.015)),
                      const IngredientChipList(),
                    ],
                  ),
                );
              },
            ),
            ChatInputArea(
              controller: _inputController,
              scrollToBottom: _scrollToBottom,
            ),
          ],
        ),
      ),
    );
  }
}
