class CategoryQueries {
  static String getCategoriesQuery() {
    return '''
        query{
            categories(
            filters: {
              parent_id: {in: ["2"]}
            }
              pageSize: 20
              currentPage: 1
          ) {
            total_count
            items {
              id
              level
              name
              image
              product_count
            }
            page_info {
              current_page
            }
          }
        }
        ''';
  }
}