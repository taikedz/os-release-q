// The package declaration names the package on-import
// Ensure it is unique-enough, or the importer needs to do `import new_name "site.tld/lib/path"`
//    to use the package as "new_name"
package version

// For a symbol to be visible externally, it must be capitalised

const VERSION_TAG string = "0.0.1"

func Version() string {
	return VERSION_TAG
}
