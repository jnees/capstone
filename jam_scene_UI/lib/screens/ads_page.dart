import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import '../models/mock_ad_results.dart';
import '../screens/ad_details_page.dart';
import '../screens/ad_results_page.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({Key? key}) : super(key: key);
  static const routeName = '/ads';

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  // Using mock data for layout building.
  late List<Map<String, dynamic>> results;
  late String currView = 'Results';
  String selectedAdId = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAds();
  }

  void _getAds() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
      results = mockAds;
      currView = 'Results';
    });
  }

  void adsPageStateUpdater(Map<String, dynamic> stateChanges) {
    setState(() {
      if (stateChanges.containsKey('_currView')) {
        currView = stateChanges['_currView'];
      }
      if (stateChanges.containsKey('_selectedAdId')) {
        selectedAdId = stateChanges['_selectedAdId'];
      }
    });
  }

  // Main View Handler for the Ads Tab.
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      switch (currView) {
        case 'Results':
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return AdResults(
              adsPageStateUpdater: adsPageStateUpdater,
              results: results,
            );
          }
        case 'AdDetails':
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return AdDetails(
              adsPageStateUpdater: adsPageStateUpdater,
              id: selectedAdId,
            );
          }
        default:
          return Center(
            child: Text('Error: Unknown view: $currView'),
          );
      }
    });
  }
}
