class PaymentMethodModel {
  String cardCategory;
  String cardNumber;
  bool isSelected = false;

  PaymentMethodModel.withDummyData(this.cardCategory, this.cardNumber,{this.isSelected=false});

  PaymentMethodModel.selected(this.cardCategory, this.cardNumber,{this.isSelected=true});
}
