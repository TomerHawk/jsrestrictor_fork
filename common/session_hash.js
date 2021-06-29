/** \file
 * \brief A cache for session and domain hashes, used for Farbling
 *
 *  \author Copyright (C) 2021  Matus Svancar
 *  \author Copyright (C) 2021  Giorgio Maone
 *
 *  \license SPDX-License-Identifier: GPL-3.0-or-later
 */
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

var Hashes = {
  sessionHash : gen_random64().toString(),
  sessionHashIncognito : gen_random64().toString(),
  visitedDomains : {},
  getFor(url, isPrivate){
    if (!url.origin) url = new URL(url);
	  let {origin} = url;
    let domainHash = this.visitedDomains[[origin,isPrivate]];
	  if (!domainHash) {
		  let hmac = isPrivate ? sha256.hmac.create(this.sessionHashIncognito) : sha256.hmac.create(this.sessionHash);
		  hmac.update(url.origin);
		  domainHash = this.visitedDomains[[origin,isPrivate]] = hmac.hex();
	  }
    return {
      domainHash
    };
  }
};
