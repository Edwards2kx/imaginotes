import 'package:flutter/material.dart';
import 'package:imaginotes/core/config/router/app_constants.dart';

import '../../domain/entities/note_entity.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    this.onTap,
    required this.note,
    this.isSelected = false,
    this.searchQuery = '',
  });

  final Function? onTap;
  final NoteEntity note;
  final bool isSelected;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.notesPagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHighlightedText(note.title, searchQuery, context),
              const SizedBox(height: 8),
              _buildHighlightedText(note.content, searchQuery, context),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    note.tags.map((tag) {
                      return Chip(label: Text(tag));
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
    String text,
    String query,
    BuildContext context,
  ) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return Text(text, maxLines: 7, overflow: TextOverflow.ellipsis);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final RegExp regExp = RegExp(
      RegExp.escape(lowerQuery),
      caseSensitive: false,
    );
    final matches = regExp.allMatches(lowerText);

    if (matches.isEmpty) {
      return Text(text, maxLines: 7, overflow: TextOverflow.ellipsis);
    }

    final List<TextSpan> children = [];
    int lastEnd = 0;

    for (final match in matches) {
      children.add(TextSpan(text: text.substring(lastEnd, match.start)));
      children.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: TextStyle(
            backgroundColor: Colors.yellow.shade300,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      children.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style:
            DefaultTextStyle.of(
              context,
            ).style, // Usa el estilo predeterminado para evitar desajustes
        children: children,
      ),
      maxLines: 7,
      overflow: TextOverflow.ellipsis,
    );
  }
}
