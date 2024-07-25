// The package declaration names the package on-import
// Ensure it is unique-enough
package osr_version

// For a symbol to be visible externally, it must be capitalised

const VERSION_TAG string = "0.0.1"

func Version() string {
	return VERSION_TAG
}