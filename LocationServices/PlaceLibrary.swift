/*
    Copyright 2020 Itreau Bigsby

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

@author   Itreau Bigsby    mailto:ibigsby@asu.edu
@version 2.0 Nov 17, 2020
 */

import Foundation

class PlaceLibrary
{
    var places : [PlaceDescription] = []
    
    init() {
        // TODO remove! Just for testing
        let testItem = PlaceDescription(name: "test", description: "test desc", category: "test cat", addrTitle: "test title", addrStreet: "test street", elevation: 10.0, latitude: 1.0, longitude: 2.0)
        places.append(testItem)
    }
}
