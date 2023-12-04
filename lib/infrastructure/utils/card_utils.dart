import 'package:flutter/material.dart';

class CardUtils {
  CardUtils._();

  static final _instance = CardUtils._();

  static CardUtils get instance => _instance;

  /// Returns [CardType] enum from card number.
  CardTypeEnum detectCardType(number) {
    RegExp regVisa = RegExp("^4[0-9]{12}(?:[0-9]{3})?\$");
    RegExp regMaster = RegExp("^5[1-5][0-9]{14}\$");
    RegExp regMaestro = RegExp(
        "^(5018|5020|5038|5612|5893|6304|6759|6761|6762|6763|0604|6390)\$");
    RegExp regRupey = RegExp("^6(?!011)(?:0[0-9]{14}|52[12][0-9]{12})\$");
    if (regVisa.hasMatch(number)) {
      return CardTypeEnum.Visa;
    } else if (regMaster.hasMatch(number)) {
      return CardTypeEnum.MasterCard;
    } else if (regMaestro.hasMatch(number)) {
      return CardTypeEnum.Maestro;
    } else if (regRupey.hasMatch(number)) {
      return CardTypeEnum.Rupey;
    } else if (number.toString().length == 16) {
      return CardTypeEnum.Others;
    } else {
      return CardTypeEnum.Invalid;
    }
  }
  /// Return card icon from card type enum.
  Widget getCardIcon(CardTypeEnum cardType) {
    String img = "";
    late Icon icon;
    Widget widget;
    switch (cardType) {
      case CardTypeEnum.MasterCard:
        img = 'mastercard.png';
        break;
      case CardTypeEnum.Visa:
        img = 'visa.png';
        break;
      case CardTypeEnum.Rupey:
        img = 'rupey.png';
        break;

      case CardTypeEnum.Maestro:
        img = 'maestro.png';
        break;

      case CardTypeEnum.Others:
        icon = Icon(
          Icons.credit_card,
          size: 20.0,
          color: Colors.grey[600],
        );
        break;

      case CardTypeEnum.Invalid:
        icon = const Icon(
          Icons.warning,
          size: 20.0,
          color: Colors.transparent,
        );
        break;
    }

    if (img.isNotEmpty) {
      widget = Image.asset(
        'assets/image/card/$img',
      );
    } else {
      widget = icon;
    }
    return widget;
  }
}

enum CardTypeEnum { Visa, MasterCard, Maestro, Rupey, Others, Invalid }
