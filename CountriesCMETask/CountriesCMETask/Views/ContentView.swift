//
//  ContentView.swift
//  CountriesCMETask
//
//  Created by Moustafa Hegazy on 17/01/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)e
//    private var items: FetchedResults<Item>

	@State private var countries: Country = []

	@State var searchResults: Country = []

	@State var searchQuery: String = ""

	var isSearching: Bool {
		return !searchQuery.isEmpty
	}

	@StateObject private var locationManager = LocationManager()


    var body: some View {
        NavigationStack {
			VStack {
				List {
					if isSearching {
						ForEach(searchResults) { item in
							NavigationLink {
								VStack {
									Text(item.name?.official ?? "")
									Spacer()
									Text(item.currencies?.first?.key ?? "")
								}
							} label: {
								Text(item.name?.official ?? "")
							}
						}
					} else {
						ForEach(countries) { item in
							NavigationLink {
								VStack {
									Text(item.name?.official ?? "")
									Spacer()
									Text(item.currencies?.first?.key ?? "")
								}
							} label: {
								Text(item.name?.official ?? "")
							}
						}.onDelete { indexSet in
							countries.remove(atOffsets: indexSet)
						}
					}


				}
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						EditButton() // should be remove
					}
					ToolbarItem {
						Button(action: addItem) {
							Label("Add Item", systemImage: "plus")
						}
					}
				}
				.navigationTitle("Countries")
				.searchable(
					text: $searchQuery,
					placement: .automatic,
					prompt: "Search Country Name"
				)
				.textInputAutocapitalization(.never)

				.onChange(of: searchQuery) { newValue in
					fetchSearchResults(for: newValue)
				}
			}
		} .onAppear {
			locationManager.getLocationCountry(completion: { country in
				fetchCountries(country: country)
			})
		}
    }

	private func fetchCountries(country: String) {
		print(country)
		let countryUrl = "https://restcountries.com/v3.1/name/\(country)?fields=name,capital,currencies,ccn3"

		var urlString = countryUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

		guard let url = URL(string: urlString) else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"  // optional
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		let task = URLSession.shared.dataTask(with: request){ data, response, error in
			if let error = error {
				print("Error while fetching data:", error)
				return
			}

			guard let data = data else {
				return
			}

			do {
				let decodedData = try JSONDecoder().decode(Country.self, from: data)
				// Assigning the data to the array
				self.countries = decodedData
			} catch let jsonError {
				print("Failed to decode json", jsonError)
			}
		}

		task.resume()
	}

	private func fetchSearchResults(for query: String) {
		// here to search web too
		guard  query.count > 2 else { return }

		let countryUrl = "https://restcountries.com/v3.1/name/\(query)?fields=name,capital,currencies,ccn3"

		let urlString = countryUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

		guard let url = URL(string: urlString) else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"  // optional
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		let task = URLSession.shared.dataTask(with: request){ data, response, error in
			if let error = error {
				print("Error while fetching data:", error)
				return
			}

			guard let data = data else {
				return
			}

			do {
				let decodedData = try JSONDecoder().decode(Country.self, from: data)
				// Assigning the data to the array
				self.searchResults = decodedData
			} catch let jsonError {
				print("Failed to decode json", jsonError)
			}
		}

		task.resume()
//		searchResults = countries.filter { country in
//			country.name?.official?
//				.lowercased()
//				.contains(searchQuery) ?? false
//		}
	}

    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
    }

    private func deleteItems(offsets: IndexPath) {
        withAnimation {

			countries.remove(at: offsets.row)

//            offsets.map { countries[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
