abstract class FetchInputRepository {
  /// A function which returns a list of states present in the repository
  Future<List?> getStateList({bool? isTest});

  /// A function which returns a list of districts for a
  /// particular `state ID` present in the repository
  Future<List?> getDistrictList(String? stateId);

  /// A function which returns a list of seasons for a
  /// particular `state ID`, `district ID` and `crop ID` present in the repository
  Future<List?> getSeasons(String? state, String? district, String? cropId);

  /// A function which returns a list of crops for a
  /// particular `state ID` and `district ID` present
  /// in the repository
  Future<List?> getCrops(String? state, String? district);

  /// Get the ZIP file containing all the data for the applied
  /// filters
  Future<void> getRequiredDownloads(
    List<String> stateIds,
    List<String> districtIds,
    List<String> years,
    List<String?> params,
  );

  /// Get the ZIP file containing all the data for the applied
  /// filters
  Future<void> getRequiredDownloadsMobile(
    List<String> stateIds,
    List<String> districtIds,
    List<String> years,
    List<String?> params,
    String fileName,
  );
}
