generate:
	dart run build_runner build --delete-conflicting-outputs

dev: generate
	flutter run
