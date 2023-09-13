import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DeliveryCompletedActionSheet extends StatelessWidget {
  final DateTime pickUpTime;
  final DateTime deliveryTime;

  const DeliveryCompletedActionSheet({
    super.key,
    required this.pickUpTime,
    required this.deliveryTime,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      builder: (builder, controller) {
        return _buildActionSheetView(context: context);
      },
    );
  }

  Stack _buildActionSheetView({required BuildContext context}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.only(start: 16, top: 66),
          margin: const EdgeInsetsDirectional.only(top: 50),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(250, 174, 43, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: _buildDeliveryInfo(context: context),
        ),
        const Align(
          alignment: AlignmentDirectional.topCenter,
          child: Material(
            shape: CircleBorder(side: BorderSide.none),
            elevation: 13,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/current_position_marker.png',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildDeliveryInfo({
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Center(
              child: Text(
                "Mohamed Abdullah",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildRateBar(context: context),
          ],
        ),
        Center(child: _buildDeliveryDetails(context: context)),
      ],
    );
  }

  RatingBar _buildRateBar({required BuildContext context}) {
    return RatingBar(
      initialRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: const Icon(Icons.star, color: Colors.yellow),
        half: const Icon(Icons.star, color: Colors.amber),
        empty: const Icon(Icons.star, color: Colors.white),
      ),
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  Column _buildDeliveryDetails({
    required BuildContext context,
  }) {
    final pickUpTime = DateFormat.jm().format(this.pickUpTime);
    final deliveryTime = DateFormat.jm().format(this.deliveryTime);
    return Column(
      children: [
        _buildDeliveryTimeDetails(context: context, title: 'Pickup Time', value: pickUpTime),
        const SizedBox(height: 16),
        _buildDeliveryTimeDetails(context: context, title: 'Delivery Time', value: deliveryTime),
        const SizedBox(height: 32),
        _buildDeliveryTimeDetails(context: context, title: 'Total', value: ''),
        const SizedBox(height: 8),
        _buildAmountAndSubmitButton(context: context, amount: '\$30.00'),
      ],
    );
  }

  Padding _buildDeliveryTimeDetails({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 40),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Padding _buildAmountAndSubmitButton({
    required BuildContext context,
    required String amount,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 40,
        bottom: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              amount,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 16,
                    bottom: 16,
                    start: 16,
                    end: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
