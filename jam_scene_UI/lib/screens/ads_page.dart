import "dart:convert";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
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
  late List<dynamic> results = [];
  late String currView = 'Results';
  int selectedAdId = -1;
  String _selectedUserId = '';
  bool _isLoading = true;
  bool _dbError = false;

  @override
  void initState() {
    super.initState();
    _getAds(true);
  }

  void _getAds(bool showLoading) async {
    if (!mounted) {
      return;
    }
    showLoading ? setState(() => _isLoading = true) : null;

    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) return;
    var url = Uri.parse('https://jam-scene-app.herokuapp.com/ads');
    var response =
        await http.get(url, headers: {'content-type': 'application/json'});

    if (response.statusCode == 200) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        results = json.decode(response.body);
        currView = 'Results';
      });
    } else {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _dbError = true;
      });
    }
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
    return _dbError
        ? const Center(child: Text("Db error, try again."))
        : Builder(builder: (context) {
            switch (currView) {
              case 'Results':
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return AdResults(
                    adsPageStateUpdater: adsPageStateUpdater,
                    refreshAds: _getAds,
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
                    adDetails:
                        results.firstWhere((ad) => ad['id'] == selectedAdId),
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
