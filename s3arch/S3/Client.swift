//
//  Client.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/15/23.
//

import Foundation
import NIO
import SotoCore
import SotoS3

// TODO: Add search

class S3Client: ObservableObject {
  let keychainData: KeychainData
  let client: AWSClient
  let s3: S3

  init(keychainData: KeychainData) {
    self.keychainData = keychainData
    self.client = AWSClient(
      credentialProvider: .static(
        accessKeyId: keychainData.accessKey,
        secretAccessKey: keychainData.accessKeySecret),
      httpClientProvider: .createNew
    )

    self.s3 = S3(client: client, region: .useast2)
  }

  func listBucketNames() -> EventLoopFuture<[String]> {
    let future = s3.listBuckets(logger: Logger(label: "Logger"))
    return future.map { response in
      return response.buckets?.compactMap { $0.name } ?? []
    }
  }

  func listFileKeys(in bucket: String) -> EventLoopFuture<[String]> {
    let request = S3.ListObjectsV2Request(bucket: bucket)
    let future = s3.listObjectsV2(request, logger: Logger(label: "Logger"))
    return future.map { response in
      return response.contents?.compactMap { $0.key } ?? []
    }
  }
}
