import 'package:flutter/material.dart';
import '../models/mock_ad_results.dart';
import '../screens/ad_details_page.dart';
import '../screens/ad_results_page.dart';
import '../screens/ad_search_page.dart';
import '../screens/ad_create_page.dart';
import '../screens/ad_profile_wrapper.dart';
import '../screens/ad_respond_page.dart';

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
  String _selectedUserId = '';
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
      if (stateChanges.containsKey('_selectedUserId')) {
        _selectedUserId = stateChanges['_selectedUserId'];
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
              adDetails: results.firstWhere((ad) => ad['id'] == selectedAdId),
            );
          }
        case 'AdSearch':
          return AdSearch(adsPageStateUpdater: adsPageStateUpdater);
        case 'AdCreate':
          return AdCreate(adsPageStateUpdater: adsPageStateUpdater);
        case 'Profile':
          return AdProfileWrapper(
              adsPageStateUpdater: adsPageStateUpdater,
              selectedUserId: _selectedUserId);
        case 'Respond':
          return Center(
            child: AdRespond(
                adsPageStateUpdater: adsPageStateUpdater,
                adDetails:
                    results.firstWhere((ad) => ad['id'] == selectedAdId)),
          );
        default:
          return Center(
            child: Text('Error: Unknown view: $currView'),
          );
      }
    });
  }
}
