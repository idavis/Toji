#region Using Directives

using NUnit.Framework;

#endregion

namespace Example.Tests
{
    [TestFixture]
    public class FooTests
    {
        [Test]
        public void TheDude()
        {
            Assert.Pass( "Abides" );
        }
    }
}