#!/usr/bin/env bash


# https://gist.github.com/trinitronx/5437061

libs=( "/usr/local/lib/libmacfuse_i32.2.dylib" \
"/usr/local/lib/libosxfuse_i32.2.dylib" \
"/usr/local/lib/libosxfuse_i64.2.dylib" \
"/usr/local/lib/libmacfuse_i64.2.dylib" \
"/usr/local/lib/libosxfuse_i32.la" \
"/usr/local/lib/libosxfuse_i64.la" \
"/usr/local/lib/pkgconfig/osxfuse.pc" )

boxcryptor="/Applications/BoxCryptor.app/Contents/Resources/Library"

[ ! -d $boxcryptor ] && mkdir -p $boxcryptor

for lib in "${libs[@]}"
do
mv $lib "${boxcryptor}/" && echo "Moved ${lib} to ${boxcryptor}." || echo "Problem moving: ${lib} to ${boxcryptor}"
rm $lib || echo "Problem removing: ${lib}"
ln -s "${boxcryptor}/$(basename $lib)" ${lib} && echo "Linked ${lib}." || echo "Problem symlinking ${lib}"
done

brew prune
brew doctor
