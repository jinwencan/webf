

/*
 * Copyright (C) 2019-present Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */

import 'package:flutter/rendering.dart';
import 'package:kraken/rendering.dart';
import 'package:kraken/css.dart';

// CSS Box Alignment: https://drafts.csswg.org/css-align/

mixin CSSFlowMixin on RenderStyleBase {

  TextAlign get textAlign {
    // Get style from self or closest parent if specified style property is not set
    // due to style inheritance.
    RenderBoxModel? renderBox = renderBoxModel!.getSelfParentWithSpecifiedStyle(TEXT_ALIGN);
    if (renderBox != null) {
      return renderBox.renderStyle._textAlign;
    }
    return _textAlign;
  }
  TextAlign _textAlign = TextAlign.start;
  set textAlign(TextAlign? value) {
    if (_textAlign == value) return;
    _textAlign = value ?? TextAlign.start;
    // Update all the children flow layout with specified style property not set due to style inheritance.
    _markFlowLayoutNeedsLayout(renderBoxModel, TEXT_ALIGN);
  }

  /// Mark flow layout and all the children flow layout with specified style property not set needs layout.
  void _markFlowLayoutNeedsLayout(RenderBoxModel? renderBoxModel, String styleProperty) {
    if (renderBoxModel is RenderFlowLayout) {
      renderBoxModel.markNeedsLayout();
      renderBoxModel.visitChildren((RenderObject child) {
        if (child is RenderFlowLayout) {
          // Only need to layout when the specified style property is not set.
          if (child.renderStyle.style[styleProperty].isEmpty) {
            _markFlowLayoutNeedsLayout(child, styleProperty);
          }
        } else if (child is RenderTextBox) {
          child.textAlign = _textAlign;
        }
      });
    }
  }

  void updateFlow(String value) {
    textAlign = _getTextAlign(value);
  }

  TextAlign _getTextAlign(String value) {
    TextAlign alignment;

    switch (value) {
      case 'end':
      case 'right':
        alignment = TextAlign.end;
        break;
      case 'center':
        alignment = TextAlign.center;
        break;
      case 'justify':
        alignment = TextAlign.justify;
        break;
      case 'start':
      case 'left':
      default:
        alignment = TextAlign.start;
      // Like inherit, which is the same with parent element.
      // Not impl it due to performance consideration.
      // case 'match-parent':
    }
    
    return alignment;
  }
}

