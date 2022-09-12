// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

export default function handler(req, res) {
  const tokenId = req.query.tokenId;

  const name = `CryptoMon #${tokenId}`;
  const description = `CryptoMon is a NFT collection for developers`;
  const image = `https://raw.githubusercontent.com/LearnWeb3DAO/NFT-Collection/main/my-app/public/cryptodevs/${
    Number(tokenId) - 1
  }.svg`;
  return res.json({ name: name, description: description, image: image });
}
