import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/business.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons.dart';
import '../../widgets/link_actions.dart';

class ChatScreen extends StatefulWidget {
  final Business business;
  const ChatScreen({super.key, required this.business});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  final _quick = const [
    '¿Está disponible?',
    '¿Hacen envíos?',
    '¿Cuál es el precio?',
    '¿Dónde los encuentro?',
  ];

  void _send(String text) {
    context.read<AppState>().sendMessage(widget.business.id, text);
    _ctrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent + 120, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final msgs = app.chatWith(widget.business.id);
    final ek = EkekoColors.of(context);
    final b = widget.business;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(gradient: AppColors.coverGradient(b.color), borderRadius: BorderRadius.circular(11)),
            alignment: Alignment.center,
            child: Icon(AppIcons.forBusiness(b.category, serviceType: b.serviceType), color: Colors.white, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(b.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              Text(b.respondsFast ? 'Suele responder en <1h' : 'En línea', style: TextStyle(fontSize: 11, color: ek.muted)),
            ],
          )),
        ]),
        actions: [
          IconButton(
            tooltip: 'Abrir WhatsApp',
            onPressed: () => LinkActions.openWhatsApp(context, b.links.whatsappPhone),
            icon: const Icon(Icons.chat_rounded, color: AppColors.success),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: msgs.isEmpty
                ? Center(child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.forum_rounded, size: 48, color: ek.muted),
                      const SizedBox(height: 12),
                      Text('Escribe a ${b.name} para coordinar tu compra.', textAlign: TextAlign.center, style: TextStyle(color: ek.muted)),
                    ]),
                  ))
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(16),
                    itemCount: msgs.length,
                    itemBuilder: (context, i) {
                      final m = msgs[i];
                      return Align(
                        alignment: m.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: m.fromMe ? AppColors.primary : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(m.fromMe ? 16 : 4), bottomRight: Radius.circular(m.fromMe ? 4 : 16),
                            ),
                            border: m.fromMe ? null : Border.all(color: ek.border),
                          ),
                          child: Text(m.text, style: TextStyle(color: m.fromMe ? Colors.white : null, fontSize: 13.5)),
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _quick.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => ActionChip(label: Text(_quick[i]), onPressed: () => _send(_quick[i])),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, border: Border(top: BorderSide(color: ek.border))),
            child: Row(children: [
              Expanded(child: TextField(
                controller: _ctrl,
                textInputAction: TextInputAction.send,
                onSubmitted: (v) { if (v.trim().isNotEmpty) _send(v.trim()); },
                decoration: const InputDecoration(hintText: 'Escribe un mensaje…', contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
              )),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () { if (_ctrl.text.trim().isNotEmpty) _send(_ctrl.text.trim()); },
                icon: const Icon(Icons.send_rounded),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
